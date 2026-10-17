{
  lib,
  stdenv,
  buildNpmPackage,
  fetchNpmDeps,
  fetchurl,
  nodejs,
  jq,
  moreutils,
  autoPatchelfHook,
  llvmPackages,
  musl,
  installShellFiles,
  versionCheckHook,
  writableTmpDirAsHomeHook,
}:

buildNpmPackage (finalAttrs: {
  pname = "cf";
  version = "1.0.0-beta.13";

  __structuredAttrs = true;
  strictDeps = true;

  inherit nodejs;

  src = fetchurl {
    url = "https://registry.npmjs.org/cf/-/cf-${finalAttrs.version}.tgz";
    hash = "sha256-tzXl9AhuCS3Wp+oI4uVxsxIZYjsTiRLvOnbGTw1uYsw=";
  };

  # The published tarball already contains the built bundle. Its devDependencies
  # reference vendored `file:` tarballs that are not published, so the committed
  # lockfile is generated without them and package.json is trimmed to match.
  postPatch = ''
    jq 'del(.devDependencies)' package.json | sponge package.json
    cp ${./package-lock.json} package-lock.json
  '';

  # Explicit so the fetcher only needs the lockfile and not jq from postPatch.
  npmDeps = fetchNpmDeps {
    name = "${finalAttrs.pname}-${finalAttrs.version}-npm-deps";
    inherit (finalAttrs) src;
    postPatch = ''
      cp ${./package-lock.json} package-lock.json
    '';
    hash = "sha256-+7dgJIB2AQgvl6fh54J9vY2rxGkjrDOjOQFIv8h2gM0=";
  };

  dontNpmBuild = true;

  nativeBuildInputs = [
    jq
    moreutils
    installShellFiles
    writableTmpDirAsHomeHook
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [ autoPatchelfHook ];

  # miniflare ships a prebuilt workerd binary
  buildInputs = [
    llvmPackages.libcxx
    llvmPackages.libunwind
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    musl # not used, but requires extra work to remove
  ];

  postInstall = ''
    # The workerd shim's postinstall copies the platform binary (~135 MB) into
    # its own bin; it resolves the platform package at runtime anyway.
    for workerd in $out/lib/node_modules/cf/node_modules/@cloudflare/workerd-*/bin/workerd; do
      ln -sfr "$workerd" $out/lib/node_modules/cf/node_modules/workerd/bin/workerd
    done
  ''
  + lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd cf \
      --bash <($out/bin/cf complete bash) \
      --zsh <($out/bin/cf complete zsh) \
      --fish <($out/bin/cf complete fish)
  '';

  doInstallCheck = true;
  nativeInstallCheckInputs = [
    versionCheckHook
    writableTmpDirAsHomeHook
  ];
  versionCheckKeepEnvironment = [ "HOME" ];

  passthru.updateScript = ./update.sh;

  meta = {
    description = "Command-line interface for the Cloudflare API and Workers projects";
    homepage = "https://developers.cloudflare.com/cf";
    downloadPage = "https://www.npmjs.com/package/cf";
    changelog = "https://github.com/cloudflare/cf/releases/tag/cf@${finalAttrs.version}";
    license = with lib.licenses; [
      mit
      asl20
    ];
    sourceProvenance = with lib.sourceTypes; [ binaryBytecode ];
    identifiers.purlParts = {
      type = "npm";
      spec = "cf@${finalAttrs.version}";
    };
    mainProgram = "cf";
    # Commands that need workerd (local dev) only work where miniflare ships a
    # prebuilt binary; everything else works wherever nodejs does.
    platforms = nodejs.meta.platforms;
    maintainers = with lib.maintainers; [ wrbbz ];
  };
})
