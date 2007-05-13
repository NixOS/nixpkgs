source $stdenv/setup

configureFlags="\
  --with-nspr-includes=$nss/include/nspr \
  --with-nspr-libs=$nss/lib \
  --with-nss-includes=$nss/include/nss \
  --with-nss-libs=$nss/lib"

genericBuild
