{ lib
, rustPlatform
, fetchFromGitHub
, makeWrapper
, taskwarrior
}:

rustPlatform.buildRustPackage rec {
  pname = "taskwarrior-tui";
  version = "0.13.12";

  src = fetchFromGitHub {
    owner = "kdheepak";
    repo = "taskwarrior-tui";
    rev = "v${version}";
    sha256 = "0q38vb7sqip18wv2d1m95bb8y0y187rqcdfcx551rgvan4x4jq70";
  };

  # Because there's a test that requires terminal access
  doCheck = false;

  nativeBuildInputs = [ makeWrapper ];
  postInstall = ''
    wrapProgram $out/bin/taskwarrior-tui --prefix PATH : "${lib.makeBinPath [ taskwarrior ]}"
  '';

  cargoSha256 = "1sk0xlbllgpc5sawbr88mpwyyl2yrl5qsbj46ih38q8f4hfp365n";

  meta = with lib; {
    description = "A terminal user interface for taskwarrior ";
    homepage = "https://github.com/kdheepak/taskwarrior-tui";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ matthiasbeyer ];
  };
}
