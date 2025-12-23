#!/bin/sh

# The file from which to extract *.ico files or a particular *.ico file.
# (e.g.: './KeePass.exe', './myLibrary.dll', './my/path/to/app.ico').
# As you notived, the utility can extract icons from a windows executable or
# dll.
rscFile=$1

# A regexp that can extract the image size from the file name. Because we
# use 'icotool', this value should usually be set to something like
# '[^\.]+\.exe_[0-9]+_[0-9]+_[0-9]+_[0-9]+_([0-9]+x[0-9]+)x[0-9]+\.png'.
# A reg expression may be written at some point that relegate this to
# an implementation detail.
sizeRegex=$2

# A regexp replace expression that will be used with 'sizeRegex' to create
# a proper size directory (e.g.: '48x48'). Usually this is left to '\1'.
sizeReplaceExp=$3

# A regexp that can extract the name of the target image from the file name
# of the image (usually png) extracted from the *.ico file(s). A good
# default is '([^\.]+).+' which gets the basename without extension.
nameRegex=$4

# A regexp replace expression that will be used alongside 'nameRegex' to create
# a icon file name. Note that you usually put directly you icon name here
# without any extension (e.g.: 'my-app'). But in case you've got something
# fancy, it will usually be '\1'.
nameReplaceExp=$5

# The
# out=./myOut
out=$6

# An optional temp dir.
if [ "" != "$7" ]; then
  tmp=$7
  isOwnerOfTmpDir=false
else
  tmp=`mktemp -d`
  isOwnerOfTmpDir=true
fi

rm -rf $tmp/png $tmp/ico
mkdir -p $tmp/png $tmp/ico

# Extract the ressource file's extension.
rscFileExt=`echo "$rscFile" | sed -re 's/.+\.(.+)$/\1/'`

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

rm -rf "$tmp/png" "$tmp/ico"

if $isOwnerOfTmpDir; then
  rm -rf "$tmp"
fi
