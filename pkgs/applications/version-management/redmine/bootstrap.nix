{ pkgs ? import <nixpkgs> {}
}:

with pkgs;

let

in stdenv.mkDerivation rec {
  version = "2.5.2";
  name = "redmine-${version}";
  __noChroot = true;
  src = fetchurl {
    url = "http://www.redmine.org/releases/${name}.tar.gz";
    sha256 = "0x0zwxyj4dwbk7l64s3lgny10mjf0ba8jwrbafsm4d72sncmacv0";
  };
  buildInputs = [
    ruby bundler libiconv libxslt libxml2 pkgconfig
    libffi imagemagickBig postgresql which stdenv
  ];
  installPhase = ''
    unset http_proxy
    unset ftp_proxy

    cp -R . $out
    cp ${./generate_nix_requirements.rb} $out/generate_nix_requirements.rb
    cd $out

    cat > config/database.yml <<EOF
    production:
      adapter: postgresql
    EOF

    bundle config --local build.nokogiri --use-system-libraries \
      --with-iconv-dir=${libiconv} \
      --with-xslt-dir=${libxslt.out} \
      --with-xml2-dir=${libxml2.out} \
      --with-pkg-config \
      --with-pg-config=${postgresql}/bin/pg_config

    bundle install --verbose --without development test rmagick --path /tmp/redmine-${version}

    HOME="/tmp/redmine-${version}" ruby generate_nix_requirements.rb
    rm -R /tmp/gems
  '';
}
