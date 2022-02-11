source $stdenv/setup

mkdir $out
for file in $files
do
  subdir=`dirname $file`
  mkdir -p $out/$subdir
  ln -s $dir/$file $out/$file
done
