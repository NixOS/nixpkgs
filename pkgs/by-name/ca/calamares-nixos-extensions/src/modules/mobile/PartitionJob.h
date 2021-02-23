/* SPDX-FileCopyrightText: 2020 Oliver Smith <ollieparanoid@postmarketos.org>
 * SPDX-License-Identifier: GPL-3.0-or-later */
#pragma once
#include "Job.h"


class PartitionJob : public Calamares::Job
{
    Q_OBJECT
public:
    PartitionJob( const QString& cmdInternalStoragePrepare,
                  const QString& cmdLuksFormat,
                  const QString& cmdLuksOpen,
                  const QString& cmdMkfsRoot,
                  const QString& cmdMount,
                  const QString& targetDeviceRoot,
                  const QString& targetDeviceRootInternal,
                  bool installFromExternalToInternal,
                  bool isFdeEnabled,
                  const QString& password);

    QString prettyName() const override;
    Calamares::JobResult exec() override;

    Calamares::JobList createJobs();

private:
    QString m_cmdInternalStoragePrepare;
    QString m_cmdLuksFormat;
    QString m_cmdLuksOpen;
    QString m_cmdMkfsRoot;
    QString m_cmdMount;
    QString m_targetDeviceRoot;
    QString m_targetDeviceRootInternal;
    bool m_installFromExternalToInternal;
    bool m_isFdeEnabled;
    QString m_password;
};
