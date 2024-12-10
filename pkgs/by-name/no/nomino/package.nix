{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "nomino";
  version = "1.3.5";

  src = fetchFromGitHub {
    owner = "yaa110";
    repo = pname;
    rev = version;
    hash = "sha256-qznue5C/6Y+54/gV1lLgJPCezW0zF2Fe2ZlMvU57+Q0=";
  };

  cargoHash = "sha256-28QXDhpcrW1flnU5WesAdbJSMrZAhIuFv2LSJHTk74Y=";

  meta = with lib; {
    description = "Batch rename utility for developers";
    homepage = "https://github.com/yaa110/nomino";
    changelog = "https://github.com/yaa110/nomino/releases/tag/${src.rev}";
    license = with licenses; [
      mit # or
      asl20
    ];
    maintainers = with maintainers; [ figsoda ];
    mainProgram = "nomino";
  };
}
