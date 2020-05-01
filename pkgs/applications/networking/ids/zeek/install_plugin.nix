{ }:
''

install_plugin(){
    name=$1
    path=$2
    version=$3
    mkdir -p /build/$1
    cp -r $2/* /build/$1/
    cd /build/$name/
    if [ $name == 'metron-bro-plugin-kafka' ] || [ $name == 'asd' ]; then
        ./configure --bro-dist=/build/zeek-$3
        make -j4 && make install
    else
         ./configure --zeek-dist=/build/zeek-$3
        make -j4 && make install
    fi
}
install_plugin $1 $2 $3

''
