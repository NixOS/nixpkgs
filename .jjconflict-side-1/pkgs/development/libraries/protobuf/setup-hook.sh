ProtobufCMakeFlags() {
  cmakeFlagsArray+=(
    -DPROTOC_EXE="@build_protobuf@/bin/protoc"
    -DProtobuf_PROTOC_EXE="@build_protobuf@/bin/protoc"
    -DProtobuf_PROTOC_EXECUTABLE="@build_protobuf@/bin/protoc"
  )
}

preConfigureHooks+=(ProtobufCMakeFlags)
