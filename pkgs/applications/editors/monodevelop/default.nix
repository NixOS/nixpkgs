{stdenv, fetchgit
, autoconf, automake, pkgconfig, shared_mime_info, intltool
, glib, mono, gtk-sharp, gnome-sharp
}:

stdenv.mkDerivation rec {
  version = "5.1.4.0";
  revision = "7d45bbe2ee22625f125d0c52548524f02d005cca";
  name = "monodevelop-${version}";
  src = fetchgit {
    url = https://github.com/mono/monodevelop.git;
    rev = revision;
    sha256 = "0qy12zdvb0jiic3pq1w9mcsz2wwxrn0m92abd184q06yg5m48g1b";
  };

  buildInputs = [
    autoconf automake pkgconfig shared_mime_info intltool
    mono gtk-sharp gnome-sharp
  ];

  preConfigure = "patchShebangs ./configure";
  preBuild = ''
    cat > ./main/buildinfo <<EOF
    Release ID: ${version}
    Git revision: ${revision}
    Build date: 1970-01-01 00:00:01
    EOF
  '';

  postInstall = ''
    for prog in monodevelop mdtool; do
    patch -p 0 $out/bin/$prog <<EOF
    2a3,5
    > export MONO_GAC_PREFIX=${gtk-sharp}:\$MONO_GAC_PREFIX
    > export PATH=${mono}/bin:\$PATH
    > export LD_LIBRARY_PATH=${glib}/lib:${gnome-sharp}/lib:${gtk-sharp}/lib:${gtk-sharp.gtk}/lib:\$LD_LIBRARY_PATH
    > 
    EOF
    done
  '';

  dontStrip = true;

  meta = with stdenv.lib; {
    platforms = platforms.linux;
  };
}
