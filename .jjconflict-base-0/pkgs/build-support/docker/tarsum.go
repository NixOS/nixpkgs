package main

import (
	"fmt"
	"io"
	"io/ioutil"
	"os"
	"github.com/docker/docker/pkg/tarsum"
)

func main() {
	ts, err := tarsum.NewTarSum(os.Stdin, true, tarsum.Version1)
	if err != nil {
		fmt.Println(err)
		os.Exit(1)
	}

	if _, err = io.Copy(ioutil.Discard, ts); err != nil {
		fmt.Println(err)
		os.Exit(1)
	}

	fmt.Println(ts.Sum(nil))
}
