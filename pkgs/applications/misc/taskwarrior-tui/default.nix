{ stdenv
, rustPlatform
, fetchFromGitHub
}:

rustPlatform.buildRustPackage rec {
  pname = "taskwarrior-tui";
  version = "0.9.5";

  src = fetchFromGitHub {
    owner = "kdheepak";
    repo = "taskwarrior-tui";
    rev = "v${version}";
    sha256 = "1348ypjphm5f46civbrcxbbahwwl2j47z1hg8ndq1cg2bh5wb8kg";
  };

  # Because there's a test that requires terminal access
  doCheck = false;

  cargoSha256 = "11zpy3whzir9mlbvf0jyscqwj9z44a6s5i1bc2cnxyciqy9b57md";

  meta = with stdenv.lib; {
    description = "A terminal user interface for taskwarrior ";
    homepage = "https://github.com/kdheepak/taskwarrior-tui";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ matthiasbeyer ];
  };
}
