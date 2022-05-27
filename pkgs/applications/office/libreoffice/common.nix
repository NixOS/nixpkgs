{ lib }:
{
  meta = with lib; {
    description = "Comprehensive, professional-quality productivity suite, a variant of openoffice.org";
    homepage = "https://libreoffice.org/";
    license = licenses.lgpl3;
    maintainers = with maintainers; [ raskin tricktron ];
    platforms = platforms.linux ++ [ "x86_64-darwin" "aarch64-darwin" ];
  };
}
