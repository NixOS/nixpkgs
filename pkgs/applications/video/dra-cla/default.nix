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
  version = "unstable-2023-03-10";

  src = fetchFromGitHub {
    owner = "CoolnsX";
    repo = "dra-cla";
    rev = "fd5e43bb32b5bc9013382917d1efacda9c3071a8";
    hash = "sha256-SMtuflVsxe0PWmzabSDy+vhIN2bTqyiYAT/T1ChY+xY=";
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
  };
}
