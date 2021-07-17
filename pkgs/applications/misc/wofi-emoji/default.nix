{ stdenv, lib, fetchFromGitHub, jq }:

let
  emojiJSON = fetchFromGitHub {
    owner = "github";
    repo = "gemoji";
    sha256 = "sha256-Tn0vba129LPlX+MRcCBA9qp2MU1ek1jYzVCqoNxCL/w=";
    rev = "v4.0.0.rc2";
  };

in stdenv.mkDerivation rec {
  pname = "wofi-emoji";
  version = "unstable-2021-05-24";

  src = fetchFromGitHub {
    owner = "dln";
    repo = pname;
    rev = "bfe35c1198667489023109f6843217b968a35183";
    sha256 = "sha256-wMIjTUCVn4uF0cpBkPfs76NRvwS0WhGGJRy9vvtmVWQ=";
  };

  nativeBuildInputs = [ jq ];

  postPatch = ''
    cp "${emojiJSON}/db/emoji.json" .
    substituteInPlace build.sh \
      --replace 'curl https://raw.githubusercontent.com/github/gemoji/master/db/emoji.json' 'cat emoji.json'
  '';

  buildPhase = ''
    runHook preBuild

    bash build.sh

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    cp wofi-emoji $out/bin

    runHook postInstall
  '';

  meta = with lib; {
    description = "Simple emoji selector for Wayland using wofi and wl-clipboard";
    homepage = "https://github.com/dln/wofi-emoji";
    license = licenses.mit;
    maintainers = [ maintainers.ymarkus ];
    platforms = platforms.all;
  };
}
