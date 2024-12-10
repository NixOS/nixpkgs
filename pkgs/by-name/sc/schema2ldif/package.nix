{ lib, stdenvNoCC, fetchurl, makeWrapper, perlPackages }:

stdenvNoCC.mkDerivation rec {
  pname = "schema2ldif";
  version = "1.3";

  src = fetchurl {
    url = "https://repos.fusiondirectory.org/sources/schema2ldif/schema2ldif-${version}.tar.gz";
    hash = "sha256-KmXdqVuINUnJ6EF5oKgk6BsT3h5ebVqss7aCl3pPjQE=";
  };

  postPatch = ''
    # Removes the root check and changes the temporary location
    # from the nix store to $PWD
    sed -i \
      -e '/You have to run this script as root/d' \
      -e 's|/\^(\.\*)\\\.schema\$/|/.*\\/(.*)\\.schema$/|g' \
      bin/ldap-schema-manager
  '';

  buildInputs = [ perlPackages.perl ];
  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    mkdir -p $out/bin $out/share/man/man1

    cp bin/{schema2ldif,ldap-schema-manager} $out/bin
    gzip -c man/schema2ldif.1 > $out/share/man/man1/schema2ldif.1.gz
    gzip -c man/ldap-schema-manager.1 > $out/share/man/man1/ldap-schema-manager.1.gz

    wrapProgram $out/bin/schema2ldif \
       --prefix PERL5PATH : "${perlPackages.makePerlPath [ perlPackages.GetoptLong ]}"
  '';

  meta = with lib; {
    description = "Utilities to manage schema in .schema and .ldif format";
    homepage = "https://www.fusiondirectory.org/schema2ldif-project-and-components/";
    license = licenses.bsd3;
    platforms = platforms.unix;
    maintainers = with maintainers; [ das_j ];
  };
}
