/* SPDX-FileCopyrightText: 2020 Oliver Smith <ollieparanoid@postmarketos.org>
 * SPDX-License-Identifier: GPL-3.0-or-later */
#include "PartitionJob.h"

#include "GlobalStorage.h"
#include "JobQueue.h"
#include "Settings.h"
#include "utils/CalamaresUtilsSystem.h"
#include "utils/Logger.h"

#include <QDir>
#include <QFileInfo>


PartitionJob::PartitionJob( QString cmdLuksFormat, QString cmdLuksOpen,
                            QString cmdMkfsRoot, QString cmdMount,
                            QString targetDeviceRoot,
                            bool isFdeEnabled, const QString& password )
    : Calamares::Job()
    , m_cmdLuksFormat (cmdLuksFormat)
    , m_cmdLuksOpen (cmdLuksOpen)
    , m_cmdMkfsRoot (cmdMkfsRoot)
    , m_cmdMount (cmdMount)
    , m_targetDeviceRoot (targetDeviceRoot)
    , m_isFdeEnabled (isFdeEnabled)
    , m_password (password)
{
}


QString
PartitionJob::prettyName() const
{
    return "Creating and formatting installation partition";
}

/* Fill the "global storage", so the following jobs (like unsquashfs) work.
   The code is similar to modules/partition/jobs/FillGlobalStorageJob.cpp in
   Calamares. */
void
FillGlobalStorage(const QString device, const QString pathMount)
{
    using namespace Calamares;

    GlobalStorage* gs = JobQueue::instance()->globalStorage();
    QVariantList partitions;
    QVariantMap partition;

    /* See mapForPartition() in FillGlobalStorageJob.cpp */
    partition[ "device"] = device;
    partition[ "mountPoint" ] = "/";
    partition[ "claimed" ] = true;

    /* Ignored by calamares modules used in combination with the "mobile"
     * module, so we can get away with leaving them empty for now. */
    partition[ "uuid" ] = "";
    partition[ "fsName" ] = "";
    partition[ "fs" ] = "";

    partitions << partition;
    gs->insert( "partitions", partitions);
    gs->insert( "rootMountPoint", pathMount);
}

Calamares::JobResult
PartitionJob::exec()
{
    using namespace Calamares;
    using namespace CalamaresUtils;
    using namespace std;

    const QString pathMount = "/mnt/install";
    const QString cryptName = "calamares_crypt";
    QString cryptDev = "/dev/mapper/" + cryptName;
    QString passwordStdin = m_password + "\n";
    QString dev = m_targetDeviceRoot;

    QList< QPair<const QStringList, const QString> > commands = {
        {{"mkdir", "-p", pathMount}, nullptr},
    };

    if ( m_isFdeEnabled ) {
        commands.append({
            {{"sh", "-c", m_cmdLuksFormat + " " + dev}, passwordStdin},
            {{"sh", "-c", m_cmdLuksOpen + " " + dev + " " + cryptName}, passwordStdin},
            {{"sh", "-c", m_cmdMkfsRoot + " " + cryptDev}, nullptr},
            {{"sh", "-c", m_cmdMount + " " + cryptDev + " " + pathMount}, nullptr},
        });
    } else {
        commands.append({
            {{"sh", "-c", m_cmdMkfsRoot + " " + dev}, nullptr},
            {{"sh", "-c", m_cmdMount + " " + dev + " " + pathMount}, nullptr}
        });
    }

    foreach( auto command, commands ) {
        const QStringList args = command.first;
        const QString stdInput = command.second;
        const QString pathRoot = "/";

        ProcessResult res = System::runCommand( System::RunLocation::RunInHost,
                                                args, pathRoot, stdInput,
                                                chrono::seconds( 120 ) );
        if ( res.getExitCode() ) {
            return JobResult::error( "Command failed:<br><br>"
                                     "'" + args.join(" ") + "'<br><br>"
                                     " with output:<br><br>"
                                     "'" + res.getOutput() + "'");
        }
    }

    FillGlobalStorage(m_isFdeEnabled ? cryptDev : dev, pathMount);
    return JobResult::ok();
}
