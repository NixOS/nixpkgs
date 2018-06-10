{ stdenv, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  name = "todiff-${version}";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "Ekleog";
    repo = "todiff";
    rev = version;
    sha256 = "0xnqw98nccnkqfdmbkblm897v981rw1fagbi5q895bpwfg0p71lk";
  };

  cargoSha256 = "0ih7lw5hbayvc66fjqwga0i7l3sb9qn0m26vnham5li39f5i3rqp";

  meta = with stdenv.lib; {
    description = "Human-readable diff for todo.txt files";
    homepage = "https://github.com/Ekleog/todiff";
    maintainers = with maintainers; [ ekleog ];
    license = licenses.mit;
    platforms = platforms.all;
  };
}
