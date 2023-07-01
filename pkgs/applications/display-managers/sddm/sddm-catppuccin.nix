{ stdenv, lib, fetchFromGitHub, flavor ? "mocha" }:
stdenv.mkDerivation {
  pname = "sddm-catppuccin-theme";
  version = "0.0.0b0";

  dontBuild = true;
  installPhase = ''
    mkdir -p $out/share/sddm/themes
    mv src/catppuccin-${flavor} $out/share/sddm/themes/catppuccin-${flavor}
  '';

  src = fetchFromGitHub {
    owner = "catppuccin";
    repo = "sddm";
    # Main @ bde6932
    rev = "bde6932e1ae0f8fdda76eff5c81ea8d3b7d653c0";
    sha256 = "ceaK/I5lhFz6c+UafQyQVJIzzPxjmsscBgj8130D4dE=";
  };

  meta = {
    description = "Soothing pastel theme for SDDM";
    homepage = "https://github.com/catppuccin/sddm";
    maintainers = [ ];
    platforms = lib.platforms.linux;
    license = [ lib.licenses.mit ];
  };
}
