{}:
''

install_plugin(){
    name=$1
    path=$2
    mkdir -p /build/$1
    cp -r $2/* /build/$1/
    cd /build/$name/

    if [ $name == 'metron-bro-plugin-kafka' ] || [ $name == 'sasd' ]; then
        export PATH="$out/bin:$PATH"
        ./configure
         make -j $NIX_BUILD_CORES && make install
    fi

    if [ $name == 'zeek-plugin-ikev2' ]; then
        ./configure --bro-dist=$ZEEK_SRC
         make -j $NIX_BUILD_CORES && make install
    fi

    if [ $name == 'zeek-community-id' ]; then
       ./configure --zeek-dist=$ZEEK_SRC
        cd build
        make -j $NIX_BUILD_CORES && make install
    fi

    if [ $name == 'zeek-postgresql' ] || [ $name == 'bro-http2' ]; then
       ./configure --zeek-dist=$ZEEK_SRC
        make -j $NIX_BUILD_CORES && make install
    fi

}

install_plugin $1 $2

''
