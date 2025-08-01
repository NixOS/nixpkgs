{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage {
  pname = "dailies";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "JachymPutta";
    repo = "dailies";
    rev = "66938203c644a54adcc1dbbe44ad37d348f3e986";
    hash = "sha256-hT+tffJ4F4VfblfYmb1o0hl5EZjU/QOgDYudKS8EvJg=";
  };

  cargoHash = "sha256-R8r6YFo0Ih7esJl/OpcNNmmmB9pGxOXCc+3/ZivaWSw=";

  meta = with lib; {
    description = "Daily journaling in plain markdown";
    homepage = "https://github.com/JachymPutta/dailies";
    license = licenses.mit;
    maintainers = with maintainers; [ JachymPutta ];
    platforms = platforms.unix;
  };
}
