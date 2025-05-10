{
  runCommand,
  gdal,
  jdk,
  lib,
  testers,
}:

let
  inherit (gdal) pname version;

in
{
  gdal-version = testers.testVersion {
    package = gdal;
    command = "gdal --version";
  };

  ogrinfo-format-geopackage = runCommand "${pname}-ogrinfo-format-geopackage" { } ''
    ${lib.getExe gdal} raster info --formats \
      | grep 'GPKG.*GeoPackage'
    touch $out
  '';

  gdalinfo-format-geotiff = runCommand "${pname}-gdalinfo-format-geotiff" { } ''
    ${lib.getExe gdal} vector info --formats \
      | grep 'GTiff.*GeoTIFF'
    touch $out
  '';

  vector-file = runCommand "${pname}-vector-file" { } ''
    echo -e "Latitude,Longitude,Name\n48.1,0.25,'Test point'" > test.csv
    ${lib.getExe gdal} vector info ./test.csv \
      | grep '"driverShortName":"CSV"'
    touch $out
  '';

  raster-file = runCommand "${pname}-raster-file" { } ''
    ${lib.getExe gdal} raster create \
      --crs "EPSG:4326" \
      --output-format GTiff \
      --output-data-type UInt16 \
      --creation-option COMPRESS=LZW \
      --nodata 255 \
      --burn 10 \
      --size 800,600 \
      ./test.tif

    ${lib.getExe gdal} raster info ./test.tif
    touch $out
  '';

  java-bindings = runCommand "${pname}-java-bindings" { } ''
    cat <<EOF > main.java
    import org.gdal.gdal.gdal;
    class Main {
      public static void main(String[] args) {
      gdal.AllRegister();
      }
    }
    EOF
    ${lib.getExe jdk} -Djava.library.path=${gdal}/lib/ -cp ${gdal}/share/java/gdal-${version}.jar main.java
    touch $out
  '';
}
