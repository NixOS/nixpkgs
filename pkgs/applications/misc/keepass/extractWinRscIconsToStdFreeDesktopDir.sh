#!/bin/sh

# The file from which to extract *.ico files.
#rscFile="./KeePass.exe"
rscFile=$1

# A regexp that can extract the image size from the file name.
# sizeRegex='[^\.]+\.exe_[0-9]+_[0-9]+_[0-9]+_[0-9]+_([0-9]+x[0-9]+)x[0-9]+\.png'
sizeRegex=$2

# sizeReplaceExp='\1'
sizeReplaceExp=$3

# A regexp that can extract the name of the target image from the file name.
# nameRegex='([^\.]+)\.exe.+'
nameRegex=$4

# nameReplaceExp='\1'
nameReplaceExp=$5

# out=./myOut
out=$6

# An optional temp dir. TODO: Generate it randomly by default instead.
tmp=./tmp
if [ "" != "$4" ]; then
    tmp=$7
fi



rm -rf $tmp/png $tmp/ico
mkdir -p $tmp/png $tmp/ico

# Extract the ressource file's extension.
rscFileExt=`echo "$rscFile" | sed -re 's/.+\.(.+)$/\1/'`

# Debug ressource file extension.
echo "rscFileExt=$rscFileExt"

if [ "ico" = "$rscFileExt" ]; then
    cp -p $rscFile $tmp/ico
else
    wrestool -x --output=$tmp/ico -t14 $rscFile
fi

icotool --icon -x --palette-size=0 -o $tmp/png $tmp/ico/*.ico

mkdir -p $out

for i in $tmp/png/*.png; do
  fn=`basename "$i"`
  size=$(echo $fn | sed -re 's/'${sizeRegex}'/'${sizeReplaceExp}'/')
  name=$(echo $fn | sed -re 's/'${nameRegex}'/'${nameReplaceExp}'/')
  targetDir=$out/share/icons/hicolor/$size/apps
  targetFile=$targetDir/$name.png
  mkdir -p $targetDir
  mv $i $targetFile
done

rm -rf $tmp/png $tmp/ico
