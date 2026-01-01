## build described at https://wiki.winehq.org/Building_Wine#Shared_WoW64
<<<<<<< HEAD
preFlags="${configureFlags[@]}"
=======
preFlags="${configureFlags}"
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

unpackPhase
cd $TMP/$sourceRoot
patchPhase

configureScript=$TMP/$sourceRoot/configure
mkdir -p $TMP/wine-wow $TMP/wine64

cd $TMP/wine64
sourceRoot=`pwd`
<<<<<<< HEAD
configureFlags=($preFlags --enable-win64)
=======
configureFlags="${preFlags} --enable-win64"
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
configurePhase
buildPhase
# checkPhase

# Remove 64 bit gstreamer from PKG_CONFIG_PATH
IFS=":" read -ra LIST_ARRAY <<< "$PKG_CONFIG_PATH"
IFS=":" read -ra REMOVE_ARRAY <<< "@pkgconfig64remove@"
NEW_LIST_ARRAY=()

for ELEMENT in "${LIST_ARRAY[@]}"; do
  TO_ADD=1
  for REMOVE in "${REMOVE_ARRAY[@]}"; do
    if [[ "$REMOVE" == "$ELEMENT" ]]; then
      TO_ADD=0
      break
    fi
  done

  if [[ $TO_ADD -eq 1 ]]; then
    NEW_LIST_ARRAY+=("$ELEMENT")
  fi
done
PKG_CONFIG_PATH=$(IFS=":"; echo "${NEW_LIST_ARRAY[*]}")

cd $TMP/wine-wow
sourceRoot=`pwd`
<<<<<<< HEAD
configureFlags=($preFlags --with-wine64=../wine64)
=======
configureFlags="${preFlags} --with-wine64=../wine64"
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
configurePhase
buildPhase
# checkPhase

eval "$preInstall"
cd $TMP/wine-wow && make install -j$NIX_BUILD_CORES
cd $TMP/wine64 && make install -j$NIX_BUILD_CORES
eval "$postInstall"
fixupPhase
