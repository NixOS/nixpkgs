{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  libxkbcommon,
  nix-update-script,
}:

rustPlatform.buildRustPackage rec {
  pname = "rwpspread";
<<<<<<< HEAD
  version = "0.5.0";
=======
  version = "0.4.0";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "0xk1f0";
    repo = "rwpspread";
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-lp9XvILpvNZtffJLyDUCo5Xyor4X4bwsfxAIqS8Hf7M=";
  };

  cargoHash = "sha256-aGy29kGwCKHBNzszYR+w+1m8gZ/lFd0MOlFHtDDzjj4=";
=======
    hash = "sha256-1i1675OiyleCXcc/uN95kyY7m5ht/rS3UKY7EmuSsrk=";
  };

  cargoHash = "sha256-NuOOg9aIa0JW+urxDVaPn66bS4H7+0tbKYNVDUV8D80=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ libxkbcommon ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Multi-Monitor Wallpaper Utility";
    homepage = "https://github.com/0xk1f0/rwpspread";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ fsnkty ];
    platforms = lib.platforms.linux;
    mainProgram = "rwpspread";
  };
}
