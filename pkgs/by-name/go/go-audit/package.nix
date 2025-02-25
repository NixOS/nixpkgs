{
  buildGoModule,
  fetchFromGitHub,
  lib,
}:

buildGoModule rec {
  pname = "go-audit";
  version = "1.2.0";

  src = fetchFromGitHub {
    owner = "slackhq";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-Li/bMgl/wj9bHpXW5gwWvb7BvyBPzeLCP979J2kyRCM=";
  };

  vendorHash = "sha256-JHimXGsUMAQqCutREsmtgDIf6Vda+it0IL3AfS86omU=";

  # Tests need network access
  doCheck = false;

  meta = with lib; {
    description = "Alternative to the auditd daemon";
    homepage = "https://github.com/slackhq/go-audit";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
    platforms = platforms.linux;
    mainProgram = "go-audit";
  };
}
