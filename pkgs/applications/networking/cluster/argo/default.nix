{ lib, buildGoModule, buildGoPackage, fetchFromGitHub }:

let
  # Argo can package a static server in the CLI using the `staticfiles` go module.
  # We build the CLI without the static server for simplicity, but the tool is still required for
  # compilation to succeed.
  # See: https://github.com/argoproj/argo/blob/d7690e32faf2ac5842468831daf1443283703c25/Makefile#L117
  staticfiles = buildGoPackage rec {
    name = "staticfiles";
    src = fetchFromGitHub {
      owner = "bouk";
      repo = "staticfiles";
      rev = "827d7f6389cd410d0aa3f3d472a4838557bf53dd";
      sha256 = "0xarhmsqypl8036w96ssdzjv3k098p2d4mkmw5f6hkp1m3j67j61";
    };

    goPackagePath = "bou.ke/staticfiles";
  };
in
buildGoModule rec {
  pname = "argo";
  version = "2.6.1";

  src = fetchFromGitHub {
    owner = "argoproj";
    repo = "argo";
    rev = "v${version}";
    sha256 = "12wq79h4m8wlzf18r66965mbbjjb62kvnxdj50ra7nxa8jjxpsmf";
  };

  modSha256 = "1394bav1k1xv9n1rvji0j9a09mibk97xpha24640jkgmy9bnmg45";

  subPackages = [ "cmd/argo" ];

  preBuild = ''
    mkdir -p ui/dist/app
    echo "Built without static files" > ui/dist/app/index.html

    ${staticfiles}/bin/staticfiles -o server/static/files.go ui/dist/app
  '';

  meta = with lib; {
    description = "Container native workflow engine for Kubernetes";
    homepage = https://github.com/argoproj/argo;
    license = licenses.asl20;
    maintainers = with maintainers; [ groodt ];
    platforms = platforms.unix;
  };
}
