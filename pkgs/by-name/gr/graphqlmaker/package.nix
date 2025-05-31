{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule {
  pname = "graphqlmaker";
  version = "0-unstable-2024-05-18";

  src = fetchFromGitHub {
    owner = "xssdoctor";
    repo = "graphqlMaker";
    rev = "ff884ce39156d8458da35c0b0b5d7eb1e1146bb5";
    hash = "sha256-H3AFCS1WoeVXUdXBV1JKrGIraJP/ql6XG++PxmWUico=";
  };

  vendorHash = "sha256-1mDOqTsQ3kHs3MEWlRcdqhjIRul7um2mfBAxObhoSlE=";

  ldflags = [
    "-s"
    "-w"
  ];

  meta = with lib; {
    description = "Tool to find graphql queries in Javascript files";
    homepage = "https://github.com/xssdoctor/graphqlMaker";
    # https://github.com/xssdoctor/graphqlMaker/issues/1
    license = licenses.unfree;
    maintainers = with maintainers; [ fab ];
    mainProgram = "graphqlMaker";
  };
}
