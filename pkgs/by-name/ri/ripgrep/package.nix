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
  writableTmpDirAsHomeHook,
}:

let
  canRunRg = stdenv.hostPlatform.emulatorAvailable buildPackages;
  rg = "${stdenv.hostPlatform.emulator buildPackages} $out/bin/rg${stdenv.hostPlatform.extensions.executable}";
in
rustPlatform.buildRustPackage rec {
  pname = "ripgrep";
  version = "14.1.1";

  src = fetchFromGitHub {
    owner = "BurntSushi";
    repo = "ripgrep";
    rev = version;
    hash = "sha256-gyWnahj1A+iXUQlQ1O1H1u7K5euYQOld9qWm99Vjaeg=";
  };

  cargoHash = "sha256-9atn5qyBDy4P6iUoHFhg+TV6Ur71fiah4oTJbBMeEy4=";

  nativeBuildInputs = [
    installShellFiles
    writableTmpDirAsHomeHook # required for wine when cross-compiling to Windows
  ]
  ++ lib.optional withPCRE2 pkg-config;
  buildInputs = lib.optional withPCRE2 pcre2;

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
  installCheckPhase = ''
    file="$(mktemp)"
    echo "abc\nbcd\ncde" > "$file"
    ${rg} -N 'bcd' "$file"
    ${rg} -N 'cd' "$file"
  ''
  + lib.optionalString withPCRE2 ''
    echo '(a(aa)aa)' | ${rg} -P '\((a*|(?R))*\)'
  '';

  meta = {
    description = "Utility that combines the usability of The Silver Searcher with the raw speed of grep";
    homepage = "https://github.com/BurntSushi/ripgrep";
    changelog = "https://github.com/BurntSushi/ripgrep/releases/tag/${version}";
    license = with lib.licenses; [
      unlicense # or
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
}
