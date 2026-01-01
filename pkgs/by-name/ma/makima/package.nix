{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  udev,
}:

rustPlatform.buildRustPackage rec {
  pname = "makima";
  version = "0.10.2";

  src = fetchFromGitHub {
    owner = "cyber-sushi";
    repo = "makima";
    rev = "v${version}";
    hash = "sha256-qvIzoYGU0WZdEPlJ3AR3uqOt2br73Vp8+ZU2xkX2si0=";
  };

  cargoHash = "sha256-8814sRjYlnWAdOOLjj0VAuDr+Hlr1xTcvqx4Ul6XhR4=";

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ udev ];

<<<<<<< HEAD
  meta = {
    description = "Linux daemon to remap and create macros for keyboards, mice and controllers";
    homepage = "https://github.com/cyber-sushi/makima";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ ByteSudoer ];
    platforms = lib.platforms.linux;
=======
  meta = with lib; {
    description = "Linux daemon to remap and create macros for keyboards, mice and controllers";
    homepage = "https://github.com/cyber-sushi/makima";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ ByteSudoer ];
    platforms = platforms.linux;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    mainProgram = "makima";
  };
}
