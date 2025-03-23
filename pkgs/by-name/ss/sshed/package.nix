{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "sshed";
  version = "1.2.0";

  src = fetchFromGitHub {
    owner = "trntv";
    repo = pname;
    rev = version;
    hash = "sha256-y8IQzOGs78T44jLcNNjPlfopyptX3Mhv2LdawqS1T+U=";
  };

  vendorHash = "sha256-21Vh5Zaja5rx9RVCTFQquNvMNvaUlUV6kfhkIvXwbVw=";

  postFixup = ''
    mv $out/bin/cmd $out/bin/sshed
  '';

  meta = with lib; {
    description = "ssh config editor and bookmarks manager";
    homepage = "https://github.com/trntv/sshed";
    license = licenses.asl20;
    maintainers = with maintainers; [ ocfox ];
    mainProgram = "sshed";
  };
}
