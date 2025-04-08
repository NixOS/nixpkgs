{
  buildGoModule,
  fetchFromGitHub,
  lib,
}:

buildGoModule rec {
  pname = "ggh";
  version = "0.1.4";

  src = fetchFromGitHub {
    owner = "byawitz";
    repo = "ggh";
    tag = "v${version}";
    hash = "sha256-itNx/AcLUQCH99ZCOXiXPWNg3mx+UhHepidqmzPY8Oc=";
  };

  vendorHash = "sha256-WPPjpxCD3WA3E7lx5+DPvG31p8djera5xRn980eaJT8=";

  meta = {
    description = "Recall your SSH sessions (also search your SSH config file)";
    license = lib.licenses.asl20;
    mainProgram = "ggh";
    homepage = "https://github.com/byawitz/ggh";
    maintainers = with lib.maintainers; [ ilyakooo0 ];
  };
}
