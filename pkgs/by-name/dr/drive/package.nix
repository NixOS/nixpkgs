{
  lib,
  buildGoModule,
  fetchFromGitHub,
  fetchpatch,
}:

buildGoModule rec {
  pname = "drive";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "odeke-em";
    repo = "drive";
    rev = "v${version}";
    hash = "sha256-mNOeOB0Tn5eqULFJZuE18PvLoHtnspv4AElmgEQKXcU=";
  };

  vendorHash = "sha256-F/ikdr7UCVlNv2yiEemyB7eIkYi3mX+rJvSfX488RFc=";

  patches = [
    # Add Go Modules support
    (fetchpatch {
      url = "https://github.com/odeke-em/drive/commit/0fb4bb2cf83a7293d9a33b00f8fc07e1c8dd8b7c.patch";
      hash = "sha256-4PxsgfufhTfmy/7N5QahIhmRa0rb2eUDXJ66pYb6jFg=";
    })
  ];

  subPackages = [ "cmd/drive" ];

  ldflags = [
    "-s"
    "-w"
  ];

  meta = with lib; {
    homepage = "https://github.com/odeke-em/drive";
    description = "Google Drive client for the commandline";
    license = licenses.asl20;
    maintainers = [ ];
    mainProgram = "drive";
  };
}
