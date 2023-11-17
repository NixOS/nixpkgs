{ lib
, stdenv
, fetchFromGitHub
, picom
, pcre2
}:

picom.overrideAttrs (oldAttrs: rec {
  pname = "compfy";
  version = "1.7.0";

  src = fetchFromGitHub {
    owner = "allusive-dev";
    repo = "compfy";
    rev = version;
    hash = "sha256-tuM+nT2dp3L5QIMZcO/W6tmDLSDt1IQposzrS5NzYpw=";
  };

  buildInputs = [ pcre2 ] ++ oldAttrs.buildInputs;
  postInstall = ''''; # This is to blank out the post install

  meta = with lib; {
    description = "A compositor for X11, based on Picom";
    homepage = "https://github.com/allusive-dev/compfy";
    license = with lib.licenses; [ mit mpl20 ];
    maintainers = with maintainers; [ allusive iogamaster ];
    mainProgram = "compfy";
    platforms = platforms.all;
  };
})
