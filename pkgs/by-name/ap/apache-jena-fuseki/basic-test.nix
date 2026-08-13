{
  runCommand,
  apache-jena-fuseki,
  curl,
}:
runCommand "fuseki-test-${apache-jena-fuseki.name}"
  {
    nativeBuildInputs = [
      curl
      apache-jena-fuseki
    ];
  }
  ''
    export FUSEKI_BASE="$PWD/fuseki-base"
    mkdir -p "$FUSEKI_BASE/db"
    FUSEKI_ARGS="--update --loc=$FUSEKI_BASE/db /dataset" fuseki start
    fuseki status
    for i in $(seq 120); do
        if  curl http://127.0.0.1:3030/dataset/data; then
            break;
        fi
        sleep 1
    done
    curl -d 'update=insert+data+{+<test://subject>+<test://predicate>+<test://object>+}' http://127.0.0.1:3030/dataset/update > /dev/null
    curl http://127.0.0.1:3030/dataset/data | grep -C999 'test://predicate'
    curl -d 'query=select+?s+?p+?o+where+{+?s+?p+?o+.+}' http://127.0.0.1:3030/dataset/query | grep -C999 'test://predicate'
    touch $out
  ''
