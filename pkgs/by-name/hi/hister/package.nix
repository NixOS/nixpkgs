{
  lib,
  buildGoModule,
  buildNpmPackage,
  fetchFromGitHub,
  nodejs_22,
  sqlite,
  yt-dlp,
  makeBinaryWrapper,
  pkg-config,
  versionCheckHook,
}:

let
  version = "0.15.0";

  src = fetchFromGitHub {
    owner = "asciimoo";
    repo = "hister";
    tag = "v${version}";
    hash = "sha256-KdwTpRQVr/f3bYIBX/KnayZQnphmZ1BDfh71/YwDVQQ=";
  };

  frontend = (buildNpmPackage.override { nodejs = nodejs_22; }) {
    pname = "hister-frontend";
    inherit version src;

    npmWorkspace = "webui/app";
    npmDepsHash = "sha256-Zx3EzDm3HUuyQAPlbM4mgycmLCRu3z/43I0D7Omz6wo=";

    # vite 8's rolldown pipeline does a dns.lookup('localhost') during `vite build`
    # which fails in darwin's relaxed sandbox without loopback access
    __darwinAllowLocalNetworking = true;

    preBuild = ''
      patchShebangs webui
    '';

    installPhase = ''
      runHook preInstall
      mkdir -p "$out"
      cp -r webui/app/build/* "$out/"
      runHook postInstall
    '';
  };
in
buildGoModule (finalAttrs: {
  pname = "hister";
  inherit version src;

  __structuredAttrs = true;

  vendorHash = "sha256-mcpXXKoz779VkIa5VV/1MYmJe5vc7ZsjDkakb5E4POA=";
  proxyVendor = true;

  nativeBuildInputs = [
    pkg-config
    makeBinaryWrapper
  ];
  buildInputs = [ sqlite ];

  tags = [ "libsqlite3" ];

  preBuild = ''
    mkdir -p server/static/app
    cp -r ${frontend}/* server/static/app/
  '';

  ldflags = [
    "-s"
    "-X main.version=${finalAttrs.version}"
  ];

  subPackages = [ "." ];

  postInstall = ''
    wrapProgram $out/bin/hister \
      --prefix PATH : ${lib.makeBinPath [ yt-dlp ]}
  '';

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  passthru = {
    inherit frontend;
  };

  meta = {
    description = "Web history on steroids - blazing fast, content-based search for visited websites";
    homepage = "https://github.com/asciimoo/hister";
    license = lib.licenses.agpl3Plus;
    maintainers = with lib.maintainers; [ FlameFlag ];
    mainProgram = "hister";
    platforms = lib.platforms.unix;
    # x86_64-darwin needs Rosetta on ARM Darwin builders.
    badPlatforms = [ "x86_64-darwin" ];
  };
})
