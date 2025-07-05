set -e

mkdir -p "$out"/bin

cat > "$out"/bin/control <<EOF
export PATH="$PATH":"$su"/bin

start()
{
  su "$user" -s /bin/sh -c 'cd $serverDir; \

  export JBOSS_JAVA_SIZING="\
  -Xms$initialHeapMem \
  -Xmx$maxHeapMem \
  -XX:MetaspaceSize=$initialMetaspaceSize \
  -XX:MaxMetaspaceSize=$maxMetaspaceSize"; \

  $serverDir/bin/$wildflyMode.sh \
  -c $wildflyConfig \
  -b $wildflyBind \
  -bmanagement $wildflyBindManagement \
  '
}

preStart()
{
  su "$user" -s /bin/sh -c 'cd $serverDir; \

  $serverDir/bin/add-user.sh \
  -u $userAdmin \
  -p $passwordAdmin \
  '
}

if [ "$cleanBoot" == "1" ]; then
  rm -rf "$serverDir"
fi

if [ ! -d "$serverDir" ]; then
  mkdir -p "$serverDir"
  cd "$serverDir"

  cp -a "$wildfly"/opt/wildfly/* .

  chown -R "$user":"$group" "$serverDir"
  for i in \`find "$serverDir" -type d\`
  do
    chmod 775 -R "\$i" 2>/dev/null
  done

  for i in \`find "$serverDir" -type f\`
  do
    chmod 664 -R "\$i" 2>/dev/null
  done

  for i in \`find "$serverDir" -name "*.sh"\`
  do
    chmod 775 -R "\$i" 2>/dev/null
  done
  preStart
fi

start

EOF

chmod +x "$out"/bin/*
