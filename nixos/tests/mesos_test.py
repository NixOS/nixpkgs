#!/usr/bin/env python
import uuid
import time
import subprocess
import os

import sys

from mesos.interface import Scheduler
from mesos.native import MesosSchedulerDriver
from mesos.interface import mesos_pb2

def log(msg):
    process = subprocess.Popen("systemd-cat", stdin=subprocess.PIPE)
    (out,err) = process.communicate(msg)

class NixosTestScheduler(Scheduler):
    def __init__(self):
        self.master_ip = sys.argv[1]
        self.download_uri = sys.argv[2]

    def resourceOffers(self, driver, offers):
        log("XXX got resource offer")

        offer = offers[0]
        task = self.new_task(offer)
        uri = task.command.uris.add()
        uri.value = self.download_uri
        task.command.value = "cat test.result"
        driver.launchTasks(offer.id, [task])

    def statusUpdate(self, driver, update):
        log("XXX status update")
        if update.state == mesos_pb2.TASK_FAILED:
            log("XXX test task failed with message: " + update.message)
            driver.stop()
            sys.exit(1)
        elif update.state == mesos_pb2.TASK_FINISHED:
            driver.stop()
            sys.exit(0)

    def new_task(self, offer):
        task = mesos_pb2.TaskInfo()
        id = uuid.uuid4()
        task.task_id.value = str(id)
        task.slave_id.value = offer.slave_id.value
        task.name = "task {}".format(str(id))

        cpus = task.resources.add()
        cpus.name = "cpus"
        cpus.type = mesos_pb2.Value.SCALAR
        cpus.scalar.value = 0.1

        mem = task.resources.add()
        mem.name = "mem"
        mem.type = mesos_pb2.Value.SCALAR
        mem.scalar.value = 32

        return task

if __name__ == '__main__':
    log("XXX framework started")

    framework = mesos_pb2.FrameworkInfo()
    framework.user = "root"
    framework.name = "nixos-test-framework"
    driver = MesosSchedulerDriver(
        NixosTestScheduler(),
        framework,
        sys.argv[1] + ":5050"
    )
    driver.run()
