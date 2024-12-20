{
  buildGoModule,
  fetchFromGitHub,
  lib,
}:

buildGoModule rec {
  pname = "hishtory";
  version = "0.320";

  src = fetchFromGitHub {
    owner = "ddworken";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-eUm545hb3pyvArkihYG/lBxBcLQVJ25NZBNmevFAozY=";
  };

  vendorHash = "sha256-xDdK91/lQRpY7i13jnLwX2eVMb5mibHchnz7ASNzXmM=";

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
