{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  ffmpeg,
  poco,
  ocl-icd,
  opencl-clhpp,
  gitUpdater,
  callPackage,
}:

stdenv.mkDerivation rec {
  pname = "sanjuuni";
  version = "0.5";

  src = fetchFromGitHub {
    owner = "MCJack123";
    repo = "sanjuuni";
    rev = version;
    hash = "sha256-wJRPD4OWOTPiyDr9dYseRA7BI942HPfHONVJGTc/+wU=";
  };

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    ffmpeg
    poco
    ocl-icd
    opencl-clhpp
  ];

  postPatch = ''
    # TODO: Remove when https://github.com/MCJack123/sanjuuni/commit/778644b164c8877e56f9f5512480dde857133815 is released
    substituteInPlace configure \
      --replace-fail "swr_alloc_set_opts" "swr_alloc_set_opts2"
  '';

  installPhase = ''
    runHook preInstall

    install -Dm755 sanjuuni $out/bin/sanjuuni

    runHook postInstall
  '';

  passthru = {
    tests = {
      run-on-nixos-artwork = callPackage ./tests/run-on-nixos-artwork.nix { };
    };
    updateScript = gitUpdater { };
  };

  meta = with lib; {
    homepage = "https://github.com/MCJack123/sanjuuni";
    description = "Command-line tool that converts images and videos into a format that can be displayed in ComputerCraft";
    changelog = "https://github.com/MCJack123/sanjuuni/releases/tag/${version}";
    maintainers = [ maintainers.tomodachi94 ];
    license = licenses.gpl2Plus;
    broken = stdenv.hostPlatform.isDarwin;
    mainProgram = "sanjuuni";
  };
}
