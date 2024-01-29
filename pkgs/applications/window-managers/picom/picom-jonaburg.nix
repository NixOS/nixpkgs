{ picom, lib, fetchFromGitHub, pcre }:

picom.overrideAttrs (oldAttrs: rec {
  pname = "picom-jonaburg";
  version = "unstable-2022-03-19";
  src = fetchFromGitHub {
    owner = "jonaburg";
    repo = "picom";
    rev = "e3c19cd7d1108d114552267f302548c113278d45";
    sha256 = "sha256-4voCAYd0fzJHQjJo4x3RoWz5l3JJbRvgIXn1Kg6nz6Y=";
  };

  nativeBuildInputs = [ pcre ] ++ oldAttrs.nativeBuildInputs;

  meta = with lib; {
    description = "A fork of picom featuring animations and improved rounded corners.";
    homepage = "https://github.com/jonaburg/picom";
    maintainers = with maintainers; oldAttrs.meta.maintainers ++ [ michaelBelsanti ];
  };
})
