{stdenv, fetchurl, gperf, flex, bison}:

stdenv.mkDerivation rec {
  name = "verilog-0.9.7";

  src = fetchurl {
    url = "mirror://sourceforge/iverilog/${name}.tar.gz";
    sha256 = "0m3liqw7kq24vn7k8wvi630ljz0awz23r3sd4rcklk7vgghp4pks";
  };

  buildInputs = [ gperf flex bison ];

  meta = {
    description = "Icarus Verilog compiler";
    repositories.git = https://github.com/steveicarus/iverilog.git;
    homepage = http://www.icarus.com;
    license = stdenv.lib.licenses.gpl2Plus;
    maintainers = with stdenv.lib.maintainers; [winden];
    platforms = with stdenv.lib.platforms; linux;
  };
}
