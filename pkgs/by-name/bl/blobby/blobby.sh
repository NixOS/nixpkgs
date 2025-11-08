#! @shell@

test -d ~/.blobby || {
  mkdir ~/.blobby
  cp -r "@out@/share/blobby"/* ~/.blobby
  chmod u+w -R ~/.blobby
  ( cd ~/.blobby; for i in *.zip; do @unzip@/bin/unzip "$i"; done )
}

exec @out@/bin/blobby.bin "$@"
