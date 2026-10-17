{
  screenshots ? true,
  video ? false,
  clipboard ? true,
  lib,
  stdenv,
  jq,
  curl,
  fetchFromGitHub,
  makeWrapper,
  maim ? null,
  xclip ? null,
  capture ? null,
}:

assert screenshots -> maim != null;
assert video -> capture != null;
assert clipboard -> xclip != null;

stdenv.mkDerivation rec {
  pname = "pb_cli-unstable";
  version = "2019-03-10";

  src = fetchFromGitHub {
    owner = "ptpb";
    repo = "pb_cli";
    rev = "6b9ce1ee45fe651d06d7c479a20026a173dd328b";
    hash = "sha256-56OolJKqjShOOsAJKvTpvhNdbCFYpKV7JH879xM6ynA=";
  };

  nativeBuildInputs = [ makeWrapper ];

  liveDeps = [
    jq
    curl
  ]
  ++ lib.optional screenshots maim
  ++ lib.optional video capture
  ++ lib.optional clipboard xclip;

  installPhase = ''
    install -Dm755 src/pb.sh $out/bin/pb

    patchShebangs $out/bin/pb
    wrapProgram $out/bin/pb \
      --prefix PATH : '${lib.makeBinPath liveDeps}'
  '';

  meta = {
    description = "No bullshit 0x0.st client";
    homepage = "https://github.com/ptpb/pb_cli";
    maintainers = [ lib.maintainers.ar1a ];
    license = lib.licenses.gpl3Plus;
    mainProgram = "pb";
  };
}
