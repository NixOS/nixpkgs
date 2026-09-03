package main

import (
	"fmt"
	"io"
	"os"
	"github.com/docker/docker/daemon/builder/remotecontext/tarsum"
)

func main() {
	ts, err := tarsum.NewTarSum(os.Stdin, true, tarsum.Version1)
	if err != nil {
		fmt.Println(err)
		os.Exit(1)
	}

	if _, err = io.Copy(io.Discard, ts); err != nil {
		fmt.Println(err)
		os.Exit(1)
	}

	fmt.Println(ts.Sum(nil))
}
