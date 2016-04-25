{ stdenv, fetchdarcs, rustPlatform, openssl, libssh }:

with rustPlatform;

buildRustPackage rec {
  name = "pijul-${version}";
  version = "0.2-6ab9ba";

  src = fetchdarcs {
    url = "http://pijul.org/";
    context = ./pijul.org.context;
    sha256 = "1cgkcr5wdkwj7s0rda90bfchbwmchgi60w5d637894w20hkplsr4";
  };

  sourceRoot = "fetchdarcs/pijul";

  depsSha256 = "110bj2lava1xs75z6k34aip7zb7rcmnxk5hmiyi32i9hs0ddsdrz";

  cargoUpdateHook = ''
    cp -r ../libpijul src/
  '';

  setSourceRoot = ''
    chmod -R u+w "$sourceRoot"
    cp -r "$sourceRoot"/../libpijul "$sourceRoot"/src/
  '';

  buildInputs = [ openssl libssh ];

  meta = with stdenv.lib; {
    homepage = https://pijul.org/;
    description = "Fast DVCS based on a categorical theory of patches";
    license = licenses.gpl3;
    platforms = stdenv.lib.platforms.unix;
    maintainers = with maintainers; [ puffnfresh ];
  };
}
