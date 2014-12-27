{ pkgs ? import <nixpkgs> {}
}:

with pkgs;

let

in stdenv.mkDerivation rec {
  version = "7.4.2";
  name = "gitlab-${version}";
  __noChroot = true;
  src = fetchurl {
    url = "https://github.com/gitlabhq/gitlabhq/archive/v${version}.zip";
    sha256 = "01iplkpa4scr0wcap6vjrc960dj15z4ciclaqswj0sz5hrp9glw6";
  };
  buildInputs = [
    ruby rubyLibs.bundler libiconv libxslt libxml2 pkgconfig
    libffi postgresql which stdenv unzip
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

    substituteInPlace Gemfile --replace 'gem "therubyracer"' ""

    bundle config --local build.nokogiri --use-system-libraries \
      --with-iconv-dir=${libiconv} \
      --with-xslt-dir=${libxslt} \
      --with-xml2-dir=${libxml2} \
      --with-pkg-config \
      --with-pg-config=${postgresql}/bin/pg_config

    HOME="/tmp/gitlab-${version}" ruby generate_nix_requirements.rb
    rm -R /tmp/gems
  '';
}
