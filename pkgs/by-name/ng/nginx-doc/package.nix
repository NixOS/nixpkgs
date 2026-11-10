{
  lib,
  stdenv,
  libxml2,
  libxslt,
  fetchFromGitHub,
}:

# Upstream maintains documentation (sources of https://nginx.org) in separate
# mercurial repository, which do not correspond to particular git commit, but at
# least has "introduced in version X.Y" comments.
#
# In other words, documentation does not necessary matches capabilities of
# $out/bin/nginx, but we have no better options.
stdenv.mkDerivation {
  pname = "nginx-doc-unstable";
  version = "0-unstable-2026-05-15";
  src = fetchFromGitHub {
    owner = "nginx";
    repo = "nginx.org";
    rev = "7884e3ae20269c6aa718dc104c0c578f797e5269";
    hash = "sha256-ut2LRZg2gyGPbili7XcOH0wZ/nI3ArA2RGWJKcZTBOk=";
  };
  nativeBuildInputs = [
    libxslt
    libxml2
  ];

  # Generated documentation is not local-friendly, since it assumes that link to directory
  # is the same as link to index.html in that directory, which is not how browsers behave
  # with local filesystem.
  #
  # TODO: patch all relative links that do not end with .html.

  # /en subdirectory must exist, relative links expect it.
  installPhase = ''
    mkdir -p $out/share/doc/nginx
    mv libxslt/en $out/share/doc/nginx
  '';

  meta = {
    description = "Reverse proxy and lightweight webserver (documentation)";
    homepage = "https://nginx.org/";
    license = lib.licenses.bsd2;
    platforms = lib.platforms.all;
    priority = 6;
    maintainers = with lib.maintainers; [ kaction ];
  };
}
