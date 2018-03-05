{ stdenv, fetchurl, makeWrapper, cmake, pkgconfig
, glibc, gnome-keyring, gtk, gtkmm, pcre, swig, sudo
, mysql, libxml2, libctemplate, libmysqlconnectorcpp
, vsqlite, tinyxml, gdal, libiodbc, libpthreadstubs
, libXdmcp, libuuid, libzip, libgnome-keyring, file
, pythonPackages, jre, autoconf, automake, libtool
, boost, glibmm, libsigcxx, pangomm, libX11, openssl
, proj, cairo, libglade
}:

let
  inherit (pythonPackages) pexpect pycrypto python paramiko;
in stdenv.mkDerivation rec {
  pname = "mysql-workbench";
  version = "6.3.8";
  name = "${pname}-${version}";

  src = fetchurl {
    url = "http://dev.mysql.com/get/Downloads/MySQLGUITools/mysql-workbench-community-${version}-src.tar.gz";
    sha256 = "1bxd828nrawmym6d8awh1vrni8dsbwh1k5am1lrq5ihp5c3kw9ka";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ cmake gnome-keyring gtk gtk.dev gtkmm pcre swig python sudo
    paramiko mysql libxml2 libctemplate libmysqlconnectorcpp vsqlite tinyxml gdal libiodbc file
    libpthreadstubs libXdmcp libuuid libzip libgnome-keyring libgnome-keyring.dev jre autoconf
    automake libtool boost glibmm glibmm.dev libsigcxx pangomm libX11 pexpect pycrypto openssl
    proj cairo cairo.dev makeWrapper libglade ] ;

  prePatch = ''
    for f in backend/wbpublic/{grt/spatial_handler.h,grtui/geom_draw_box.h,objimpl/db.query/db_query_Resultset.cpp} ;
    do
      sed -i 's@#include <gdal/@#include <@' $f ;
    done

    sed -i '32s@mysqlparser@mysqlparser sqlparser@' library/mysql.parser/CMakeLists.txt

    cat <<EOF > ext/antlr-runtime/fix-configure
    #!${stdenv.shell}
    echo "fixing bundled antlr3c configure" ;
    sed -i 's@/usr/bin/file@${file}/bin/file@' configure
    sed -i '12121d' configure
    EOF
    chmod +x ext/antlr-runtime/fix-configure
    sed -i '236s@&&@& ''${PROJECT_SOURCE_DIR}/ext/antlr-runtime/fix-configure &@' CMakeLists.txt

    substituteInPlace $(pwd)/frontend/linux/workbench/mysql-workbench.in --replace "catchsegv" "${glibc.bin}/bin/catchsegv"
    substituteInPlace $(pwd)/frontend/linux/workbench/mysql-workbench.in --replace "/usr/lib/x86_64-linux-gnu" "${proj}/lib"
    patchShebangs $(pwd)/library/mysql.parser/grammar/build-parser
    patchShebangs $(pwd)/tools/get_wb_version.sh
  '';

  NIX_CFLAGS_COMPILE = [
    "-I${libsigcxx}/lib/sigc++-2.0/include"
    "-I${pangomm}/lib/pangomm-1.4/include"
    "-I${glibmm}/lib/giomm-2.4/include"
  ];

  cmakeFlags = [
    "-DCMAKE_CXX_FLAGS=-std=c++11"
    "-DMySQL_CONFIG_PATH=${mysql}/bin/mysql_config"
    "-DCTemplate_INCLUDE_DIR=${libctemplate}/include"
    "-DCAIRO_INCLUDE_DIRS=${cairo.dev}/include"
    "-DGTK2_GDKCONFIG_INCLUDE_DIR=${gtk}/lib/gtk-2.0/include"
    "-DGTK2_GLIBCONFIG_INCLUDE_DIR=${gtk.dev}/include"
    "-DGTK2_GTKMMCONFIG_INCLUDE_DIR=${gtkmm}/lib/gtkmm-2.4/include"
    "-DGTK2_GDKMMCONFIG_INCLUDE_DIR=${gtkmm}/lib/gdkmm-2.4/include"
    "-DGTK2_GLIBMMCONFIG_INCLUDE_DIR=${glibmm}/lib/glibmm-2.4/include"
  ];

  postInstall = ''
    patchShebangs $out/share/mysql-workbench/extras/build_freetds.sh

    for i in $out/lib/mysql-workbench/modules/wb_utils_grt.py \
             $out/lib/mysql-workbench/modules/wb_server_management.py \
             $out/lib/mysql-workbench/modules/wb_admin_grt.py; do
      substituteInPlace $i \
        --replace "/bin/bash" ${stdenv.shell} \
        --replace "/usr/bin/sudo" ${sudo}/bin/sudo
    done

    wrapProgram "$out/bin/mysql-workbench" \
      --prefix LD_LIBRARY_PATH : "${python}/lib" \
      --prefix LD_LIBRARY_PATH : "$(cat ${stdenv.cc}/nix-support/orig-cc)/lib64" \
      --prefix PATH : "${gnome-keyring}/bin" \
      --prefix PATH : "${python}/bin" \
      --set PYTHONPATH $PYTHONPATH \
      --run '
# The gnome-keyring-daemon must be running.  To allow for environments like
# kde, xfce where this is not so, we start it first.
# It is cleaned up using a supervisor subshell which detects that
# the parent has finished via the closed pipe as terminate signal idiom,
# used because we cannot clean up after ourselves due to the exec call.

# Start gnome-keyring-daemon, export the environment variables it asks us to set.
for expr in $( gnome-keyring-daemon --start ) ; do eval "export "$expr ; done

# Prepare fifo pipe.
FIFOCTL="/tmp/gnome-keyring-daemon-ctl.$$.fifo"
[ -p $FIFOCTL ] && rm $FIFOCTL
mkfifo $FIFOCTL

# Supervisor subshell waits reading from pipe, will receive EOF when parent
# closes pipe on termination.  Negate read with ! operator to avoid subshell
# quitting when read EOF returns 1 due to -e option being set.
(
    exec 19< $FIFOCTL
    ! read -u 19

    kill $GNOME_KEYRING_PID
    rm $FIFOCTL
) &

exec 19> $FIFOCTL
            '
  '';

  meta = with stdenv.lib; {
    description = "Visual MySQL database modeling, administration and querying tool";
    longDescription = ''
      MySQL Workbench is a modeling tool that allows you to design
      and generate MySQL databases graphically. It also has administration
      and query development modules where you can manage MySQL server instances
      and execute SQL queries.
    '';

    homepage = http://wb.mysql.com/;
    license = licenses.gpl2;
    maintainers = [ maintainers.kkallio ];
    platforms = [ "x86_64-linux" ];
  };
}
