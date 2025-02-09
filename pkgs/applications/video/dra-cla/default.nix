{ lib
, stdenvNoCC
, fetchFromGitHub
, makeWrapper
, gnugrep
, gnused
, curl
, mpv
, aria2
, ffmpeg
, openssl
}:

stdenvNoCC.mkDerivation {
  pname = "dra-cla";
  version = "unstable-2023-10-10";

  src = fetchFromGitHub {
    owner = "CoolnsX";
    repo = "dra-cla";
    rev = "12e9557fb8dfdff7350e0102a625170bb69acf01";
    hash = "sha256-cGY/FRV2BAS4fzJqIfD7FlIPIS0fCIIBenQYjB2dEsc=";
  };

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    runHook preInstall

    install -Dm755 dra-cla $out/bin/dra-cla

    wrapProgram $out/bin/dra-cla \
      --prefix PATH : ${lib.makeBinPath [ gnugrep gnused curl mpv aria2 ffmpeg openssl ]}

    runHook postInstall
  '';

  meta = with lib; {
    homepage = "https://github.com/CoolnsX/dra-cla";
    description = "A cli tool to browse and play korean drama, chinese drama";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ idlip ];
    platforms = platforms.unix;
    mainProgram = "dra-cla";
  };
}
