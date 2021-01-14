{ stdenv
, buildGoModule
, fetchFromGitHub
, sqlite
}:

buildGoModule rec {
  pname = "expenses";
  version = "0.2.1";

  src = fetchFromGitHub {
    owner = "manojkarthick";
    repo = "expenses";
    rev = "v${version}";
    sha256 = "11wxaqbnrrg0rykx5905chi6rhmai1nqggdbhh6hiappr5rksl0j";
  };

  vendorSha256 = "1kwj63wl4kb16zl3lmi9bzj1az7vi453asdy52na0mjx4ymmjyk1";

  # package does not contain any tests as of v0.2.1
  doCheck = false;

  buildInputs = [ sqlite ];

  buildFlagsArray = [
    "-ldflags=-s -w -X github.com/manojkarthick/expenses/cmd.Version=${version}"
  ];

  meta = with stdenv.lib; {
   description = "An interactive command line expense logger";
   license = licenses.mit;
   maintainers = [ maintainers.manojkarthick ];
  };
}
