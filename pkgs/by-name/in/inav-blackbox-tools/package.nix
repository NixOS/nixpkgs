{
  lib,
  stdenv,
  fetchFromGitHub,
  gitMinimal,
  pkg-config,
  cairo,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "inav-blackbox-tools";
  version = "9.0.0";

  strictDeps = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "iNavFlight";
    repo = "blackbox-tools";
    tag = "v${finalAttrs.version}";
    hash = "sha256-AWlf7Tfi2rwtvZB8xCCjzUvblhwDsgUB357VyCfTdUo=";
    leaveDotGit = true;
  };

  nativeBuildInputs = [
    gitMinimal
    pkg-config
  ];

  buildInputs = [ cairo ];

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/bin"
    cp obj/{blackbox_decode,blackbox_render,encoder_testbed} "$out/bin"

    runHook postInstall
  '';

  meta = {
    description = "Tools for working with blackbox flight logs";
    homepage = "https://github.com/inavflight/blackbox-tools";
    license = lib.licenses.gpl3Only;
    maintainers = [ ];
    platforms = lib.platforms.all;
    broken = stdenv.hostPlatform.isDarwin; # never built on Hydra https://hydra.nixos.org/job/nixpkgs/trunk/inav-blackbox-tools.x86_64-darwin
  };
})
