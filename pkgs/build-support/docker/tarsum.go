package main

import (
    "tarsum"
    "io"
    "io/ioutil"
    "fmt"
    "os"
)

func main() {
    ts, err := tarsum.NewTarSum(os.Stdin, false, tarsum.Version1)
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