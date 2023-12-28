{ stdenv
, lib
, fetchFromGitHub
, rustPlatform
, makeWrapper
, alass
}:

rustPlatform.buildRustPackage rec {
  pname = "sub-batch";
  version = "2.0.0";

  src = fetchFromGitHub {
    owner = "kl";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-B/FOMjoMzuTqv7B/ntJkzyTVIcPY8nXw0RtIeAmXWeo=";
  };

  cargoSha256 = "sha256-tuQ9hfou/sLlm/jANhXYeZ+s4iqwG0lFR+tbowK49y4=";

  nativeBuildInputs = [ makeWrapper alass ];

  postInstall = ''
    wrapProgram "$out/bin/sub-batch" --prefix PATH : "${lib.makeBinPath [ alass ]}"
  '';

  meta = with lib; {
    description = "Match and rename subtitle files to video files and perform other batch operations on subtitle files";
    homepage = "https://github.com/kl/sub-batch";
    license = licenses.mit;
    maintainers = with maintainers; [ erictapen ];
    broken = stdenv.isDarwin;
    mainProgram = "sub-batch";
  };
}
