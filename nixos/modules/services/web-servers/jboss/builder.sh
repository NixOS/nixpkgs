set -e

if [ -e "$NIX_ATTRS_SH_FILE" ]; then . "$NIX_ATTRS_SH_FILE"; elif [ -f .attrs.sh ]; then . .attrs.sh; fi
source $stdenv/setup

mkdir -p $out/bin

cat > $out/bin/control <<EOF
mkdir -p $logDir
chown -R $user $logDir
export PATH=$PATH:$su/bin

start()
{
  su $user -s /bin/sh -c "$jboss/bin/run.sh \
      -Djboss.server.base.dir=$serverDir \
      -Djboss.server.base.url=file://$serverDir \
      -Djboss.server.temp.dir=$tempDir \
      -Djboss.server.log.dir=$logDir \
      -Djboss.server.lib.url=$libUrl \
      -c default"
}

stop()
{
  su $user -s /bin/sh -c "$jboss/bin/shutdown.sh -S"
}

if test "\$1" = start
then
  trap stop 15

  start
elif test "\$1" = stop
then
  stop
elif test "\$1" = init
then
  echo "Are you sure you want to create a new server instance (old server instance will be lost!)?"
  read answer

  if ! test \$answer = "yes"
  then
    exit 1
  fi

  rm -rf $serverDir
  mkdir -p $serverDir
  cd $serverDir
  cp -av $jboss/server/default .
  sed -i -e "s|deploy/|$deployDir|" default/conf/jboss-service.xml

  if ! test "$useJK" = ""
  then
    sed -i -e 's|<attribute name="UseJK">false</attribute>|<attribute name="UseJK">true</attribute>|' default/deploy/jboss-web.deployer/META-INF/jboss-service.xml
    sed -i -e 's|<Engine name="jboss.web" defaultHost="localhost">|<Engine name="jboss.web" defaultHost="localhost" jvmRoute="node1">|' default/deploy/jboss-web.deployer/server.xml
  fi

  # Make files accessible for the server user

  chown -R $user $serverDir
  for i in \`find $serverDir -type d\`
  do
    chmod 755 \$i
  done
  for i in \`find $serverDir -type f\`
  do
    chmod 644 \$i
  done
fi
EOF

chmod +x $out/bin/*
