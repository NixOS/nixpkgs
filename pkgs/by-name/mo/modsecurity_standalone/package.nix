{ stdenv, lib, fetchFromGitHub, pkg-config, autoreconfHook
, curl, apacheHttpd, pcre, apr, aprutil, libxml2
, luaSupport ? false, lua5, perl
}:

let luaValue = if luaSupport then lua5 else "no";
    optional = lib.optional;
in

stdenv.mkDerivation rec {
  pname = "modsecurity";
  version = "2.9.7";

  src = fetchFromGitHub {
    owner = "owasp-modsecurity";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-hJ8wYeC83dl85bkUXGZKHpHzw9QRgtusj1/+Coxsx0k=";
  };

  nativeBuildInputs = [ pkg-config autoreconfHook ];
  buildInputs = [  curl apacheHttpd pcre apr aprutil libxml2 ] ++
    optional luaSupport lua5;

  configureFlags = [
    "--enable-standalone-module"
    "--enable-static"
    "--with-curl=${curl.dev}"
    "--with-apxs=${apacheHttpd.dev}/bin/apxs"
    "--with-pcre=${pcre.dev}"
    "--with-apr=${apr.dev}"
    "--with-apu=${aprutil.dev}/bin/apu-1-config"
    "--with-libxml=${libxml2.dev}"
    "--with-lua=${luaValue}"
  ];

  outputs = ["out" "nginx"];
  # by default modsecurity's install script copies compiled output to httpd's modules folder
  # this patch removes those lines
  patches = [ ./Makefile.am.patch ];

  doCheck = true;
  nativeCheckInputs = [ perl ];

  postInstall = ''
    mkdir -p $nginx
    cp -R * $nginx
  '';

  meta = with lib; {
    description = "Open source, cross-platform web application firewall (WAF)";
    license = licenses.asl20;
    homepage = "https://github.com/owasp-modsecurity/ModSecurity";
    maintainers = with maintainers; [offline];
    platforms   = lib.platforms.linux ++ lib.platforms.darwin;
  };
}
