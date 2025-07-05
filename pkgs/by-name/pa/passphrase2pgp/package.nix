{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:

buildGoModule rec {
  pname = "passphrase2pgp";
  version = "1.3.0";

  src = fetchFromGitHub {
    owner = "skeeto";
    repo = "passphrase2pgp";
    rev = "v${version}";
    hash = "sha256-it1XYzLiteL0oq4SZp5E3s6oSkFKi3ZY0Lt+P0gmNag=";
  };

  vendorHash = "sha256-2H9YRVCaari47ppSkcQYg/P4Dzb4k5PLjKAtfp39NR8=";

  postInstall = ''
    mkdir -p $out/share/doc/$name
    cp README.md $out/share/doc/$name
  '';

  checkPhase = ''
    output=$(echo NONE | ../go/bin/passphrase2pgp -a -u NONE -i /dev/stdin | sha256sum)
    if [[ "$output" != "23f59f4346f35e2feca6ef703ea64973524dec365ea672f23e7afe79be1049dd  -" ]] ; then
      echo "passphrase2pgp introduced backward-incompatible change"
      exit 1
    fi
  '';

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    description = "Predictable, passphrase-based PGP key generator";
    mainProgram = "passphrase2pgp";
    homepage = "https://github.com/skeeto/passphrase2pgp";
    license = licenses.unlicense;
    maintainers = with maintainers; [ kaction ];
  };
}
