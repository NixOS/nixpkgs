{
  lib,
  stdenv,
  buildPackages,
  fetchFromGitHub,
  rustPlatform,
  installShellFiles,
  pkg-config,
  withPCRE2 ? true,
  pcre2,
  rust-jemalloc-sys,
  writableTmpDirAsHomeHook,
}:

let
  canRunRg = stdenv.hostPlatform.emulatorAvailable buildPackages;
  rg = "${stdenv.hostPlatform.emulator buildPackages} $out/bin/rg${stdenv.hostPlatform.extensions.executable}";
in
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "ripgrep";
  version = "16.0.0";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "BurntSushi";
    repo = "ripgrep";
    tag = finalAttrs.version;
    hash = "sha256-EW+k5vMcWYUdaTKpcyZcXj9DgIfsiesuJPrOD+5O/O8=";
  };

  cargoHash = "sha256-jq74hAlDGhkKHKkiLezAwnR0UDKc7Ydt3KYdMajagz4=";

  nativeBuildInputs = [
    installShellFiles
    writableTmpDirAsHomeHook # required for wine when cross-compiling to Windows
  ]
  ++ lib.optional withPCRE2 pkg-config;
  buildInputs =
    lib.optional withPCRE2 pcre2 ++ lib.optional stdenv.hostPlatform.isStatic rust-jemalloc-sys;

  buildFeatures = lib.optional withPCRE2 "pcre2";

  postFixup = lib.optionalString canRunRg ''
    ${rg} --generate man > rg.1
    installManPage rg.1

    installShellCompletion --cmd rg \
      --bash <(${rg} --generate complete-bash) \
      --fish <(${rg} --generate complete-fish) \
      --zsh <(${rg} --generate complete-zsh)
  '';

  doInstallCheck = true;
  installCheckPhase = lib.optionalString canRunRg (
    ''
      file="$(mktemp)"
      echo "abc\nbcd\ncde" > "$file"
      ${rg} -N 'bcd' "$file"
      ${rg} -N 'cd' "$file"
    ''
    + lib.optionalString withPCRE2 ''
      echo '(a(aa)aa)' | ${rg} -P '\((a*|(?R))*\)'
    ''
  );

  meta = {
    description = "Utility that combines the usability of The Silver Searcher with the raw speed of grep";
    homepage = "https://github.com/BurntSushi/ripgrep";
    changelog = "https://github.com/BurntSushi/ripgrep/releases/tag/${finalAttrs.version}";
    license =
      with lib.licenses;
      OR [
        unlicense
        mit
      ];
    maintainers = with lib.maintainers; [
      globin
      ma27
      zowoq
    ];
    mainProgram = "rg";
    platforms = lib.platforms.all;
  };
})
