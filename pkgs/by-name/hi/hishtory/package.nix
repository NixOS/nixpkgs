{
  buildGoModule,
  fetchFromGitHub,
  lib,
}:

buildGoModule rec {
  pname = "hishtory";
  version = "0.324";

  src = fetchFromGitHub {
    owner = "ddworken";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-CcRRMHUvLVrJ0fWsAH+SUxcSB2koOShlqBnnhKtrCts=";
  };

  vendorHash = "sha256-A975ensuezz75I4KrFcl8wi9HjZqlfEHeJVAyA69V9k=";

  ldflags = [ "-X github.com/ddworken/hishtory/client/lib.Version=${version}" ];

  subPackages = [ "." ];

  excludedPackages = [ "backend/server" ];

  postInstall = ''
    mkdir -p $out/share/hishtory
    cp client/lib/config.* $out/share/hishtory
  '';

  doCheck = true;

  meta = with lib; {
    description = "Your shell history: synced, queryable, and in context";
    homepage = "https://github.com/ddworken/hishtory";
    license = licenses.mit;
    maintainers = [ ];
    mainProgram = "hishtory";
  };
}
